import Sound
import lean_certs.cert_36_112

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_112_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 36) (d := 112) (c := cert_36_112) (by decide)
