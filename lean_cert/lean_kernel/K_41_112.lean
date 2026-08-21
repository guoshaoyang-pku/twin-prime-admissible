import Sound
import lean_certs.cert_41_112

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_112_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 41) (d := 112) (c := cert_41_112) (by decide)
