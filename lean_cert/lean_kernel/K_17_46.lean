import Sound
import lean_certs.cert_17_46

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H17_gt_46_kernel : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 46 := by
  exact certValidRoot_sound (k := 17) (d := 46) (c := cert_17_46) (by decide)
