import Sound
import lean_certs.cert_30_112

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_112_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 30) (d := 112) (c := cert_30_112) (by decide)
