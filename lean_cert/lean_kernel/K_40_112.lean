import Sound
import lean_certs.cert_40_112

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_112_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 40) (d := 112) (c := cert_40_112) (by decide)
