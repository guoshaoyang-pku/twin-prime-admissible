import Sound
import lean_certs.cert_38_98

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_98_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 38) (d := 98) (c := cert_38_98) (by decide)
