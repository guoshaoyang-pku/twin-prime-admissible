import Sound
import lean_certs.cert_16_38

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H16_gt_38_kernel : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 38 := by
  exact certValidRoot_sound (k := 16) (d := 38) (c := cert_16_38) (by decide)
