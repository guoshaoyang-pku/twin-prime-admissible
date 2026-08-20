import Sound
import lean_certs.cert_41_182

open CertVerify

theorem H41_gt_182 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 182 := by
  exact certValidRoot_sound (k := 41) (d := 182) (c := cert_41_182) (by native_decide)
