import Sound
import lean_certs.cert_44_134

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_134_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 44) (d := 134) (c := cert_44_134) (by decide)
