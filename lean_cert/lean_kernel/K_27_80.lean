import Sound
import lean_certs.cert_27_80

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_80_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 27) (d := 80) (c := cert_27_80) (by decide)
