import Sound
import lean_certs.cert_27_112

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_112_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 27) (d := 112) (c := cert_27_112) (by decide)
