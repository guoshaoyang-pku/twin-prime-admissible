import Sound
import lean_certs.cert_15_46

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H15_gt_46_kernel : ¬ ∃ t : List Nat, admissible 15 t = true ∧ diameter t ≤ 46 := by
  exact certValidRoot_sound (k := 15) (d := 46) (c := cert_15_46) (by decide)
