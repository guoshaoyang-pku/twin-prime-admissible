import Sound
import lean_certs.cert_37_82

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_82_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 37) (d := 82) (c := cert_37_82) (by decide)
