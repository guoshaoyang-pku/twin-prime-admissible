import Sound
import lean_certs.cert_31_98

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H31_gt_98_kernel : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 31) (d := 98) (c := cert_31_98) (by decide)
