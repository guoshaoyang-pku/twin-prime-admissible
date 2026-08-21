import Sound
import lean_certs.cert_49_112

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_112_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 49) (d := 112) (c := cert_49_112) (by decide)
