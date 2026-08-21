import Sound
import lean_certs.cert_46_116

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_116_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 46) (d := 116) (c := cert_46_116) (by decide)
