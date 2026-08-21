import Sound
import lean_certs.cert_26_98

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_98_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 26) (d := 98) (c := cert_26_98) (by decide)
