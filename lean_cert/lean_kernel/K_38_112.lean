import Sound
import lean_certs.cert_38_112

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_112_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 38) (d := 112) (c := cert_38_112) (by decide)
