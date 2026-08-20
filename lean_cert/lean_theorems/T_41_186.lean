import Sound
import lean_certs.cert_41_186

open CertVerify

theorem H41_gt_186 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 186 := by
  exact certValidRoot_sound (k := 41) (d := 186) (c := cert_41_186) (by native_decide)
