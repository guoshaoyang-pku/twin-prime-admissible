import Sound
import lean_certs.cert_38_90

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_90_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 38) (d := 90) (c := cert_38_90) (by decide)
