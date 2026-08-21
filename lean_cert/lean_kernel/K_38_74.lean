import Sound
import lean_certs.cert_38_74

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_74_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 38) (d := 74) (c := cert_38_74) (by decide)
