import Sound
import lean_certs.cert_36_154

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_154_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 36) (d := 154) (c := cert_36_154) (by decide)
