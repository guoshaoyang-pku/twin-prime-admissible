import Sound
import lean_certs.cert_48_202

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_202_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 202 := by
  exact certValidRoot_sound (k := 48) (d := 202) (c := cert_48_202) (by decide)
