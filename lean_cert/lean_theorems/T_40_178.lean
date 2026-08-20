import Sound
import lean_certs.cert_40_178

open CertVerify

theorem H40_gt_178 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 178 := by
  exact certValidRoot_sound (k := 40) (d := 178) (c := cert_40_178) (by native_decide)
