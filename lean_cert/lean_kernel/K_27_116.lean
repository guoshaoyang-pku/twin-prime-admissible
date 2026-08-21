import Sound
import lean_certs.cert_27_116

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H27_gt_116_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 27) (d := 116) (c := cert_27_116) (by decide)
