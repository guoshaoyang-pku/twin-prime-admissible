import Sound
import lean_certs.cert_37_160

open CertVerify

theorem H37_gt_160 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 37) (d := 160) (c := cert_37_160) (by native_decide)
