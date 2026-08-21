import Sound
import lean_certs.cert_40_154

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_154_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 40) (d := 154) (c := cert_40_154) (by decide)
