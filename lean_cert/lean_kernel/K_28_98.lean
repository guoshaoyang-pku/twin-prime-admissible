import Sound
import lean_certs.cert_28_98

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_98_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 28) (d := 98) (c := cert_28_98) (by decide)
