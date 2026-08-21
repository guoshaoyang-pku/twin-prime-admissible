import Sound
import lean_certs.cert_17_40

open CertVerify

theorem H17_gt_40 : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 40 := by
  exact certValidRoot_sound (k := 17) (d := 40) (c := cert_17_40) (by native_decide)
