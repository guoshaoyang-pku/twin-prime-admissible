import Sound
import lean_certs.cert_48_98

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_98_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 48) (d := 98) (c := cert_48_98) (by decide)
