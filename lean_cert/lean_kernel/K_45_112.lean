import Sound
import lean_certs.cert_45_112

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_112_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 45) (d := 112) (c := cert_45_112) (by decide)
