import Sound
import lean_certs.cert_31_82

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H31_gt_82_kernel : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 31) (d := 82) (c := cert_31_82) (by decide)
