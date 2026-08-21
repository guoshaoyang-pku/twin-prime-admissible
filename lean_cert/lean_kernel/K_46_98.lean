import Sound
import lean_certs.cert_46_98

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_98_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 46) (d := 98) (c := cert_46_98) (by decide)
