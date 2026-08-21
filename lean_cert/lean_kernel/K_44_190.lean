import Sound
import lean_certs.cert_44_190

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_190_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 190 := by
  exact certValidRoot_sound (k := 44) (d := 190) (c := cert_44_190) (by decide)
