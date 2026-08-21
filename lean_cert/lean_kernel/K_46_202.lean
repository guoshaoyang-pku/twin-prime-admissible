import Sound
import lean_certs.cert_46_202

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H46_gt_202_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 202 := by
  exact certValidRoot_sound (k := 46) (d := 202) (c := cert_46_202) (by decide)
