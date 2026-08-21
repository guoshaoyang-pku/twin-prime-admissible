import Sound
import lean_certs.cert_18_46

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H18_gt_46_kernel : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 46 := by
  exact certValidRoot_sound (k := 18) (d := 46) (c := cert_18_46) (by decide)
