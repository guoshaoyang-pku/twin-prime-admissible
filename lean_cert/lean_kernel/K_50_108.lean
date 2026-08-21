import Sound
import lean_certs.cert_50_108

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_108_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 50) (d := 108) (c := cert_50_108) (by decide)
