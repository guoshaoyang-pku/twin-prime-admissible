import Sound
import lean_certs.cert_38_154

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_154_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 38) (d := 154) (c := cert_38_154) (by decide)
