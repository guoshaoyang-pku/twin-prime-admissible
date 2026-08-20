import Sound
import lean_certs.cert_41_152

open CertVerify

theorem H41_gt_152 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 41) (d := 152) (c := cert_41_152) (by native_decide)
