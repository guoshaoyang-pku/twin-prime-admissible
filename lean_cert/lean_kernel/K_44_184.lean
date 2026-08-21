import Sound
import lean_certs.cert_44_184

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_184_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 184 := by
  exact certValidRoot_sound (k := 44) (d := 184) (c := cert_44_184) (by decide)
