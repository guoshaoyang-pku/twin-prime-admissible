import Sound
import lean_certs.cert_44_164

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_164_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 44) (d := 164) (c := cert_44_164) (by decide)
