import Sound
import lean_certs.cert_46_154

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_154_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 46) (d := 154) (c := cert_46_154) (by decide)
