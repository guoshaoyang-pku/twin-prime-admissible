import Sound
import lean_certs.cert_41_154

open CertVerify

theorem H41_gt_154 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 41) (d := 154) (c := cert_41_154) (by native_decide)
