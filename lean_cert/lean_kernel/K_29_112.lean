import Sound
import lean_certs.cert_29_112

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_112_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 29) (d := 112) (c := cert_29_112) (by decide)
