import Sound
import lean_certs.cert_37_152

open CertVerify

theorem H37_gt_152 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 37) (d := 152) (c := cert_37_152) (by native_decide)
