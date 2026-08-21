import Sound
import lean_certs.cert_44_202

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H44_gt_202_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 202 := by
  exact certValidRoot_sound (k := 44) (d := 202) (c := cert_44_202) (by decide)
