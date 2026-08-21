import Sound
import lean_certs.cert_47_202

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_202_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 202 := by
  exact certValidRoot_sound (k := 47) (d := 202) (c := cert_47_202) (by decide)
