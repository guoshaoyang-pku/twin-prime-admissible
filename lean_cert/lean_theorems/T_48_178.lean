import Sound
import lean_certs.cert_48_178

open CertVerify

theorem H48_gt_178 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 178 := by
  exact certValidRoot_sound (k := 48) (d := 178) (c := cert_48_178) (by native_decide)
