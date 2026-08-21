import Sound
import lean_certs.cert_50_112

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_112_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 50) (d := 112) (c := cert_50_112) (by decide)
