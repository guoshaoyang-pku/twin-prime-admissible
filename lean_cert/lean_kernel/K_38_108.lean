import Sound
import lean_certs.cert_38_108

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_108_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 38) (d := 108) (c := cert_38_108) (by decide)
