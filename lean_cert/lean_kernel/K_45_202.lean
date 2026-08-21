import Sound
import lean_certs.cert_45_202

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H45_gt_202_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 202 := by
  exact certValidRoot_sound (k := 45) (d := 202) (c := cert_45_202) (by decide)
