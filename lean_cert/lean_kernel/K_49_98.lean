import Sound
import lean_certs.cert_49_98

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_98_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 49) (d := 98) (c := cert_49_98) (by decide)
