import Sound
import lean_certs.cert_36_98

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_98_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 36) (d := 98) (c := cert_36_98) (by decide)
