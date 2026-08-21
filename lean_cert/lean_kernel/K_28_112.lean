import Sound
import lean_certs.cert_28_112

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_112_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 28) (d := 112) (c := cert_28_112) (by decide)
