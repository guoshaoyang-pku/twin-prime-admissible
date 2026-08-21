import Sound
import lean_certs.cert_34_134

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_134_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 34) (d := 134) (c := cert_34_134) (by decide)
