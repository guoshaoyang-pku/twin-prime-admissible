import Sound
import lean_certs.cert_37_92

open CertVerify

theorem H37_gt_92 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 37) (d := 92) (c := cert_37_92) (by native_decide)
